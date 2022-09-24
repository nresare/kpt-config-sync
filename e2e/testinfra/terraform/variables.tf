/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project" {
  type = string
  description = "Name of GCP project"
}

variable "prow" {
  type = bool
  description = "Whether to provision prow e2e clusters"
  default = false
}

variable "num_clusters" {
  type = number
  description = "How many user clusters to provision. Used for dev clusters (prow=false)."
  default = 1
}