#------------------------------------------------
# ECR
#------------------------------------------------

resource "aws_ecr_repository" "default" {
  name                 = var.repository_name
  image_tag_mutability = var.tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

#------------------------------------------------
# ECR_LIFE_CYCLE
#------------------------------------------------

resource "aws_ecr_lifecycle_policy" "default_tagged" {
  repository = aws_ecr_repository.default.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 50 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 50
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

#------------------------------------------------
# ECR_LIFE_CYCLE
#------------------------------------------------

resource "aws_ecr_lifecycle_policy" "default_untagged" {
  repository = aws_ecr_repository.default.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 30 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

#------------------------------------------------
# ECR_POLICY
#------------------------------------------------

resource "aws_ecr_repository_policy" "fb_policy" {
  repository = aws_ecr_repository.default.name

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountPush",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::503015512028:root",
          "arn:aws:iam::907131024408:root",
          "arn:aws:iam::885170164782:root"
        ]
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImageScanFindings",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    }
  ]
}
EOF
}
