terraform {
  backend "s3" {
    bucket = "chatapp-terraform"
    key    = "tfstate/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
    region = "us-west-2"
    access_key = ""
    secret_key = ""
}

# Create Redis Instance For Staging

resource "aws_elasticache_cluster" "chatapp_staging_redis" {
  cluster_id           = "chatapp-staging-redis"
  engine               = "redis"
  engine_version       = "3.2.10"
  maintenance_window   = "thu:06:00-thu:07:00"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  port                 = 6379
  security_group_ids   = ["sg-04af2c63", "sg-5ba4b72b"]
}

# Grabbing data from production

data "aws_db_snapshot" "db_snapshot" {
    most_recent = true
    db_instance_identifier = "chatapp"
}


# Create new staging DB from production data

resource "aws_db_instance" "chatapp_stagingdb" {
  instance_class       = "db.t2.micro"
  identifier           = "chatapp-stagingdb"
  username             = "postgres"
  password             = "change-me"
  publicly_accessible  = true
  db_subnet_group_name = "default"
  snapshot_identifier  = "${data.aws_db_snapshot.db_snapshot.id}"
  vpc_security_group_ids = ["sg-04af2c63","sg-5ba4b72b"]
  skip_final_snapshot = true
}
