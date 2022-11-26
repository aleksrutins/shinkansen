use anyhow::{anyhow, Error};
use git2::Repository;

pub fn snatch(repo_url: String) -> Result<Repository, Error> {
    let Some(repo_name) = repo_url.split('/').last() else {
        return Err(anyhow!("Invalid repository URL"))
    };
    let repo_path = format!("{}/.guacamole/{}", dirs::home_dir().expect("No home directory found").to_str().unwrap(), repo_name);
    let repo = Repository::init(&repo_path)?;
    
    {
        let mut remote = repo.remote("origin", &repo_url)?;
        remote.fetch(&[remote.default_branch()?.as_str().unwrap()], None, None)?;
    }
    
    Ok(repo)
}