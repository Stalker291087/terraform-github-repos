output "clone-urls" {
  value = { for i in github_repository.github-repository : i.name => {
    ssh_clone_url  = i.ssh_clone_url
    http_clone_url = i.http_clone_url
    pages_url      = try(i.pages[0].html_url, "no pages to display")
    }
  }
  description = "Repository URLs"
  sensitive   = false
}
