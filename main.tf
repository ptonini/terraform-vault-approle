resource "vault_policy" "this" {
  count = var.policy_definitions == null ? 0 : 1
  name   = "approle-${var.name}"
  policy = join("\n\n", var.policy_definitions)
}

resource "vault_approle_auth_backend_role" "this" {
  role_name             = var.name
  backend               = try(var.backend.path, var.backend)
  token_policies        = concat(vault_policy.this[*].name, var.policies)
  secret_id_bound_cidrs = var.secret_id_bound_cidrs
}

resource "vault_approle_auth_backend_role_secret_id" "this" {
  backend   = try(var.backend.path, var.backend)
  role_name = vault_approle_auth_backend_role.this.role_name
}