
resource "random_id" "random" {
  byte_length = 2
}

# Repository resource block
resource "github_repository" "github-repository" {
  for_each    = var.repositories
  name        = "slothsultions-repo-${each.key}-${var.env}"
  description = "${each.value.lang} Repository"
  visibility  = var.env == "prod" ? "private" : "public"
  auto_init   = true
  dynamic "pages" {
    for_each = each.value.pages ? [1] : []
    content {
      source {
        branch = "main"
        path   = "/"
      }
    }
  }


  provisioner "local-exec" {
    command = "gh repo view ${self.name} --web"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf /home/jean/git_repositories/${self.name}"
  }
}

# Fake resource
resource "terraform_data" "provisioner_gitclone" {
  for_each   = var.repositories
  depends_on = [github_repository.github-repository, github_repository_file.readme-file, github_repository_file.main-file]

  provisioner "local-exec" {
    command = "git clone ${github_repository.github-repository[each.key].ssh_clone_url}"
  }

}

# Readme file resource block
resource "github_repository_file" "readme-file" {
  for_each   = var.repositories
  repository = github_repository.github-repository[each.key].name
  branch     = "main"
  file       = "README.md"
  content = templatefile("${path.module}/templates/readme.tpl", {
    lang       = each.value.lang
    env        = var.env
    authorname = data.github_user.github_current_user.name
  })
  # content             = <<-EOT
  #                         # This reposiroty is for ${each.value.lang} developers - ${var.env}\nWas last modified by ${data.github_user.github_current_user.name}
  #                       EOT
  commit_message      = "Adding new readme file"
  commit_author       = data.github_user.github_current_user.name
  commit_email        = data.github_user.github_current_user.email
  overwrite_on_create = true
  lifecycle {
    ignore_changes = [
      content,
    ]
  }
}

resource "github_repository_file" "main-file" {
  for_each            = var.repositories
  repository          = github_repository.github-repository[each.key].name
  branch              = "main"
  file                = each.value.filename
  content             = "Hello ${each.value.lang}"
  commit_message      = "Adding index.html file"
  commit_author       = data.github_user.github_current_user.name
  commit_email        = data.github_user.github_current_user.email
  overwrite_on_create = true
  lifecycle {
    ignore_changes = [
      content,
    ]
  }
}

# Rename resources in the state file
# moved {
#   from = github_repository_file.index-file
#   to = github_repository_file.main-file
# }