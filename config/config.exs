# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"

config :nerves_firmware_ssh,
  authorized_keys: [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1KfjmUl0x5odBzeFf7bQTUI+TG9o+SNvtHdBVYjzuQLYzKsjvffX9nfZgli0ScyzkH98InS10XBwzjp5M8foa1VWHQUL3PduGgQVS9VgBIL8nKaznYlpiuKvxXmw9gwoiqFGlZScTYUHiNCcaFI9p7uBuEmPvj9yfxZV2Kgv1+MHSoRqdtr4t7NK+UcHzqAZt/NLQxLnXfSWEbnAdxvnXr/bReDbC2KHuenf3/brq78hcGnSVFqtyGpHvOBy8HSXOuc8W72TYrORmcB/RT/Fv5LwRltLU24MYXh37XTxhsh7iRH322X/Rjp3G8eE9rvo9RZEwFsMoxU8SKjfZvNQGFV6LfgbV61gv5lreK6CUggpFoTIhUynNCsvXpIJ0nZTqDGxtAElGfYnCAYkTvIDOj5GW3o2jAnppZ905CG/Oe+7sQ/JWdelan0FKsm+5Qb754mNa0ugwalR2rohf1xo0FIVvBvSu1JlV36e32Bmg6UF86kATZxSlWl9VlauplLvRjreXkTehDV+/wSmTsVOkD5uTCxxOvzIEjSfy/zgGyB+c4RwOQmh1uw9rh0FbdPQhjyYUt7aCMWjyePs0j0e+6g8uBY3/w70q3a6P5cLgEdjQYseJLVNGJA7v7TT0cpr565qtH6gjJpFILe6momGVVRab54W1RWa7AVe64AZveQ=="
  ]

#config :nerves_init_gadget,
#  ifname: "usb0",
#  address_method: :linklocal,
#  mdns_domain: "synapse-1.local",
#  node_name: nil,
#  node_host: :mdns_domain

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  mdns_domain: "synapse-1.local",
  node_name: nil,
  node_host: :mdns_domain

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"
config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]
