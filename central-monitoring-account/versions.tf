# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: MIT-0 */
terraform {
  required_version = ">= 1.8.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }

  }
}
