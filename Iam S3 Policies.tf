provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create an IAM Group
resource "aws_iam_group" "s3_access_group" {
  name = "s3-access-group"
}

# Attach S3 Read-Only Policy to the Group
resource "aws_iam_group_policy_attachment" "s3_read_only_group_policy" {
  group      = aws_iam_group.s3_access_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Create an IAM User
resource "aws_iam_user" "s3_user" {
  name = "s3-user"
}

# Add the User to the Group
resource "aws_iam_user_group_membership" "s3_user_group_membership" {
  user  = aws_iam_user.s3_user.name
  groups = [aws_iam_group.s3_access_group.name]
}

# Create an IAM Role
resource "aws_iam_role" "s3_role" {
  name = "s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach S3 Full Access Policy to the Role
resource "aws_iam_role_policy_attachment" "s3_full_access_role_policy" {
  role       = aws_iam_role.s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Output values (optional)
output "iam_user_name" {
  value = aws_iam_user.s3_user.name
}

output "iam_group_name" {
  value = aws_iam_group.s3_access_group.name
}

output "iam_role_name" {
  value = aws_iam_role.s3_role.name
}
