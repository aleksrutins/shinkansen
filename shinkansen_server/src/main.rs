mod resolve;

use std::net::SocketAddr;

use axum::response::Html;
use axum::routing::get;
use axum::Router;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();
    
    let app = Router::new()
        .route("/", get(root));
    
    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));
    tracing::debug!("listening on {}", addr);
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn root() -> Html<&'static str> {
    Html("
        <style>
            body {
                max-width: 60%;
                margin: auto;
                font-family: Arial, Helvetica, sans-serif;
                margin-top: 10px;
            }
            code {
                background-color: #f2f2f2;
                border-radius: 5px;
                padding: 2px;
            }
            pre code {
                display: block;
                border-radius: 5px;
                padding: 6px;
            }
        </style>
        <body>
        <h1>Welcome to Shinkansen, a Nix package version resolver!</h1>

        <p>
        To request a package version, go to /resolve/<i>package</i>/<i>version</i>, and you will receive a response similar to the following:
        </p>

<pre><code>{
    \"name\": \"<i>package name</i>\",
    \"hash\": \"<i>nixpkgs hash to use to find the package</i>\",
    \"overlay\": <i>overlay URL, or null if it's in the main nixpkgs repository</i>
}
</code></pre>

<p>
Or, if there's an error, you will receive a JSON object with an <code>error</code> field describing the error.
</p>
</body>")
}