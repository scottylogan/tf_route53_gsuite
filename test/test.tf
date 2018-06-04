module "dns" {
  source        = ".."
  domain        = "example.com"
  site_verifier = "12345"
  dkim          = "MIG..."

  extra_txts = [
    "foo=bar",
    "fubar=3",
  ]
}
