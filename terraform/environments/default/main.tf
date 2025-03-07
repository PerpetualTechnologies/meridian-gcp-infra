module "Meridian" {
  source = "../../modules/meridian"

  local_storage_device_name = local.meridian_storage_device_name
}
