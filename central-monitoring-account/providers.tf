# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: MIT-0 */

provider "aws" {
  region = var.central_cwalarms_region
  assume_role {
    role_arn    = "arn:aws:iam::533267182883:role/cross_account_admin_role"
    external_id = "terraform-assume-role"
  }
}
