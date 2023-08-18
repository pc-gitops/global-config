variable "repo_name" {
  type        = string
  description = "ECR Repo name"
}

variable "tags" {
  type        = map(string)
  description = "resource specific tags"
  default     = {
    customer   = "weaveworks-cx"
    projectGid = "99999"
    creator    = "paul-carlton@weave.works"
  }
}

variable "cluster_name" {
  type        = string
  description = "name of cluster to associate permissions with"
}

variable "awsAccountId" {
  type        = string
  description = "AWS account id"
  default     = ""
}

variable "awsRegion" {
  type        = string
  description = "AWS region"
  default     = ""
}

variable "cluster_oidc_provider_url" {
  type        = string
  description = "url for cluster oidc provider"
}

variable "cluster_oidc_provider_arn" {
  type        = string
  description = "arn for cluster oidc provider"
}

variable "service_account" {
  type        = string
  description = "kubernetes service account"
}

variable "sa_namespace" {
  type        = string
  description = "namespace for kubernetes service account"
}

variable "ecr_role" {
  type        = string
  description = "ecr_role created by eks config and assigned to source controller service account"
  default = ""
}
