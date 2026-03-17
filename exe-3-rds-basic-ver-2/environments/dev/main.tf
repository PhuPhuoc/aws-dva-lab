module "network" {
  source = "../../modules/network"
}

module "security_group" {
  source = "../../modules/security_group"

  vpc_id = module.network.vpc_id
}

module "database" {
  source = "../../modules/database"

  db_subnet_name = module.network.db_subnet_name
  rds_sg_id      = module.security_group.rds_sg_id
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}
