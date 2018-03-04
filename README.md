# Deploylight

A light that blinks based on Visual Studio Online release build status.

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

First,

  * `export MIX_TARGET=rpi0`
  * `export NERVES_NETWORK_KEY_MGMT=WPA-PSK` can be one of (`WPA-PSK` | `NONE`)
  * `export NERVES_NETWORK_SSID=YourWifi`
  * `export NERVES_NETWORK_PSK=WifiPassword`

Then to push firmware over the air:
  * Add the ssh private key to this project exactly as `.ssh/id_rsa`
  * `mix firmware.push --user-dir .ssh synapse-1.local`

To start your Nerves app with an SD card:
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
