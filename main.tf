provider "aws" {
   region     = "us-east-1"
}

## Group Creation##
resource "aws_iam_group" "trainees" {
  name = "walmart-trainees"
  path = "/users/"
}

## Ec2 policy##
resource "aws_iam_policy" "walmart_ec2policy" {
  name        = "walmart-ec2policy"
  path        = "/"
  description = "walmart custom policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": "ec2:*",
          "Resource": "*",
          "Condition": {
              "StringEqualsIfExists": {
                  "ec2:InstanceType": [
                      "t2.micro",
                      "t2.small"
                  ]
              }
          }
      }
  ]
}
EOF
}

## RDS policy##
resource "aws_iam_policy" "walmart_rdspolicy" {
  name        = "walmart-rdspolicy"
  path        = "/"
  description = "walmart custom policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
              "rds:StartDBCluster",
              "rds:ResetDBParameterGroup",
              "rds:DescribeEngineDefaultParameters",
              "rds:CreateOptionGroup",
              "rds:CreateDBSubnetGroup",
              "rds:PurchaseReservedDBInstancesOffering",
              "rds:ModifyDBParameterGroup",
              "rds:AddSourceIdentifierToSubscription",
              "rds:DownloadDBLogFilePortion",
              "rds:CopyDBParameterGroup",
              "rds:AddRoleToDBCluster",
              "rds:ModifyDBClusterParameterGroup",
              "rds:ModifyDBClusterSnapshotAttribute",
              "rds:DeleteDBInstance",
              "rds:StopDBCluster",
              "rds:CreateDBParameterGroup",
              "rds:DescribeDBSnapshots",
              "rds:DeleteDBSnapshot",
              "rds:DescribeDBSecurityGroups",
              "rds:PromoteReadReplica",
              "rds:DeleteDBSubnetGroup",
              "rds:CreateDBSnapshot",
              "rds:DescribeValidDBInstanceModifications",
              "rds:DeleteDBSecurityGroup",
              "rds:DescribeOrderableDBInstanceOptions",
              "rds:ModifyDBCluster",
              "rds:CreateDBClusterSnapshot",
              "rds:DeleteDBParameterGroup",
              "rds:DescribeCertificates",
              "rds:CreateDBClusterParameterGroup",
              "rds:ModifyDBSnapshotAttribute",
              "rds:RemoveTagsFromResource",
              "rds:DescribeOptionGroups",
              "rds:CreateEventSubscription",
              "rds:ModifyOptionGroup",
              "rds:RestoreDBClusterFromSnapshot",
              "rds:DescribeDBEngineVersions",
              "rds:DescribeDBSubnetGroups",
              "rds:DescribeDBParameterGroups",
              "rds:DescribeReservedDBInstancesOfferings",
              "rds:DeleteOptionGroup",
              "rds:FailoverDBCluster",
              "rds:DeleteEventSubscription",
              "rds:RemoveSourceIdentifierFromSubscription",
              "rds:DescribeDBInstances",
              "rds:DescribeEngineDefaultClusterParameters",
              "rds:RevokeDBSecurityGroupIngress",
              "rds:DescribeDBParameters",
              "rds:DescribeEventCategories",
              "rds:ModifyCurrentDBClusterCapacity",
              "rds:DeleteDBCluster",
              "rds:ResetDBClusterParameterGroup",
              "rds:RestoreDBClusterToPointInTime",
              "rds:DescribeEvents",
              "rds:AddTagsToResource",
              "rds:DescribeDBClusterSnapshotAttributes",
              "rds:DescribeDBClusterParameters",
              "rds:DescribeEventSubscriptions",
              "rds:CopyDBSnapshot",
              "rds:CopyDBClusterSnapshot",
              "rds:ModifyEventSubscription",
              "rds:DescribeDBLogFiles",
              "rds:CopyOptionGroup",
              "rds:DescribeDBSnapshotAttributes",
              "rds:DeleteDBClusterSnapshot",
              "rds:ListTagsForResource",
              "rds:CreateDBCluster",
              "rds:CreateDBSecurityGroup",
              "rds:RebootDBInstance",
              "rds:DescribeDBClusterSnapshots",
              "rds:DescribeOptionGroupOptions",
              "rds:DownloadCompleteDBLogFile",
              "rds:DeleteDBClusterParameterGroup",
              "rds:ApplyPendingMaintenanceAction",
              "rds:DescribeAccountAttributes",
              "rds:DescribeDBClusters",
              "rds:DescribeDBClusterParameterGroups",
              "rds:ModifyDBSubnetGroup"
          ],
          "Resource": "*",
          "Condition": {
              "StringEqualsIfExists": {
                  "rds:DatabaseClass": "db.t2.small"
             }
          }
      }
  ]
}

EOF
}

## group and policy attachment##
resource "aws_iam_group_policy_attachment" "walmart-ec2attach" {
  group      = "${aws_iam_group.trainees.name}"
  policy_arn = "${aws_iam_policy.walmart_ec2policy.arn}"
}

resource "aws_iam_group_policy_attachment" "walmart-rdsattach" {
  group      = "${aws_iam_group.trainees.name}"
  policy_arn = "${aws_iam_policy.walmart_rdspolicy.arn}"
}



## User Creation##

resource "aws_iam_user" "walmart-users" {
  count = 3
  name = "${element(var.users, count.index)}"
  path = "/system/"
}

## User key generate ##

#resource "aws_iam_access_key" "walmart-users" {
#  count = 3
#  user  = "${element(var.users, count.index)}"
#  pgp_key = "keybase:mohansrini"
#password_reset_required = "${var.password_reset_required}"
#}

resource "aws_iam_user_login_profile" "walmart-users" {
  count   = 3
  user   = "${element(var.users, count.index)}"
  pgp_key = "keybase:mohansrini"
}

output "password" {
  value = "$[{aws_iam_user_login_profile.walmart-users.encrypted_password}]"
}
## add user to group##
resource "aws_iam_group_membership" "walmart-member" {
  name  = "walmart-trainee-group-membership"
  count= 3
  group = "${aws_iam_group.trainees.name}"
  users = ["${element(var.users, count.index)}"]
}






