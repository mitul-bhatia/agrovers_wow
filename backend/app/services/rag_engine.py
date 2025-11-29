"""
RAG (Retrieval-Augmented Generation) Engine for knowledge base retrieval.

Loads FAISS index and metadata, retrieves relevant chunks based on:
- Parameter being asked about
- Language preference
- User query

To modify:
- Change embedding model: Update `embedding_model_name` in config.py
- Change retrieval strategy: Modify `retrieve()` method
- Add new parameters: Ensure knowledge base chunks have correct metadata
"""

import os
import pickle
import json
from typing import List, Dict, Any, Optional
import numpy as np
import faiss
from ..config import settings
from ..models import Language


class RAGEngine:
    """
    RAG engine for retrieving relevant knowledge base chunks.
    
    Uses FAISS for fast similarity search and filters by parameter + language.
    OPTIMIZED: No embedding model loaded at runtime (uses keyword matching instead)
    """
    
    def __init__(self):
        """Initialize RAG engine by loading index only (no embedding model)."""
        self.index: Optional[faiss.Index] = None
        self.metadata: Dict[str, Dict[str, Any]] = {}
        self._load_index()
    
    def _load_index(self) -> None:
        """Load FAISS index and metadata from disk."""
        # Resolve paths relative to backend/ directory
        backend_dir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
        embeddings_dir = os.path.join(backend_dir, settings.embeddings_dir)
        
        index_path = os.path.join(embeddings_dir, "kb_index.faiss")
        meta_path = os.path.join(embeddings_dir, "kb_index_meta.pkl")
        
        if not os.path.exists(index_path) or not os.path.exists(meta_path):
            print(f"⚠ Index files not found at {embeddings_dir}")
            print("  Run preprocessing script first to build index.")
            return
        
        try:
            self.index = faiss.read_index(index_path)
            with open(meta_path, "rb") as f:
                self.metadata = pickle.load(f)
            print(f"✓ Loaded FAISS index with {self.index.ntotal} chunks")
        except Exception as e:
            print(f"✗ Error loading index: {e}")
            # Don't raise - allow app to start without RAG (helper mode won't work)
            self.index = None
            self.metadata = {}
    
    def retrieve(
        self,
        query: str,
        parameter: str,
        language: Language,
        k: int = 4
    ) -> List[str]:
        """
        Retrieve top-k relevant chunks for a query.
        
        OPTIMIZED: Uses keyword matching instead of embeddings to save memory.
        
        Args:
            query: User's question or context
            parameter: Current parameter being asked about
            language: Language preference ("hi" or "en")
            k: Number of chunks to retrieve
            
        Returns:
            List of text chunks (strings) most relevant to query
        """
        if self.index is None:
            return []
        
        # Use keyword-based retrieval instead of embeddings
        # This saves 90MB+ of RAM by not loading sentence-transformers
        
        # Score all chunks based on keyword matching
        scored_chunks = []
        
        for chunk_id, chunk_meta in self.metadata.items():
            
            # Get chunk info
            chunk_param = chunk_meta.get("parameter", "").lower()
            chunk_lang = chunk_meta.get("language", "en")
            chunk_text = chunk_meta.get("text", "")
            chunk_type = chunk_meta.get("section_type", "")
            
            if not chunk_text or len(chunk_text) < 20:
                continue
            
            # Calculate relevance score based on keyword matching
            score = 0.0
            
            # Boost for parameter match (fuzzy)
            param_keywords = {
                "color": ["color", "रंग", "colour"],
                "moisture": ["moisture", "नमी", "wet", "dry", "गीली", "सूखी"],
                "smell": ["smell", "गंध", "odor", "scent"],
                "ph": ["ph", "acid", "alkaline", "अम्ल", "क्षार"],
                "soil_type": ["soil type", "मिट्टी", "clay", "sandy", "loamy", "चिकनी", "रेतीली"],
                "earthworms": ["earthworm", "केंचुए", "worm"],
                "location": ["location", "स्थान", "place"],
                "fertilizer_used": ["fertilizer", "खाद", "manure"],
            }
            
            keywords = param_keywords.get(parameter, [parameter])
            if any(kw in chunk_param or kw in chunk_text.lower()[:200] for kw in keywords):
                score += 10.0  # Strong boost for parameter match
            
            # Boost for query keywords in text
            query_words = query.lower().split()
            for word in query_words:
                if len(word) > 3 and word in chunk_text.lower():
                    score += 2.0
            
            # Boost for "how to test" sections
            if chunk_type == "how_to_test" or "कैसे जांचें" in chunk_text or "how to" in chunk_text.lower():
                score += 5.0
            
            # Boost for matching language
            if chunk_lang == language:
                score += 3.0
            
            # Penalize JSON/code chunks
            if chunk_text.strip().startswith("{") or "```json" in chunk_text:
                score = 0.0
            
            if score > 0:
                scored_chunks.append((score, chunk_text, chunk_lang))
        
        # Sort by score and return top k
        scored_chunks.sort(key=lambda x: x[0], reverse=True)
        
        # Prefer same language but include others if needed
        same_lang_chunks = [text for score, text, lang in scored_chunks if lang == language]
        other_lang_chunks = [text for score, text, lang in scored_chunks if lang != language]
        
        result = same_lang_chunks[:k]
        if len(result) < k:
            result.extend(other_lang_chunks[:k - len(result)])
        
        return result[:k]
    
    def is_ready(self) -> bool:
        """Check if RAG engine is ready (index loaded)."""
        return self.index is not None

