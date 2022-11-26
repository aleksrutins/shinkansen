use axum::{Json, extract::Path};
use serde::{Serialize, Deserialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct ResolveResponse {
    pub name: String,
    pub hash: String,
}

pub fn resolve(Path(package): Path<String>, Path(version): Path<String>) -> Json<ResolveResponse> {
    Json(ResolveResponse{
        
        name: "Hello".into(),
        hash: "237r8tuigjf".into()
    })
}