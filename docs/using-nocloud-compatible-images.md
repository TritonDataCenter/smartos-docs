# Using Cloud-init with NoCloud Compatible Images

SmartOS release [20260306T044811Z][smartos-20260306T044811Z]
introduced support for [cloud-init's NoCloud][nocloud]
datasource for bhyve guests.

To use this feature, a guest must be provisioned from an image tagged with
`org.smartos:cloudinit_datasource=nocloud`.

## Behavior

When an instance is created, SmartOS uses instance metadata to build a 16 MiB
FAT disk containing these files:

- [user-data][user-data]: populated from
  `customer_metadata['cloud-init:user-data']`, or an empty `#cloud-config`
  document if that is not set
- [meta-data][meta-data]: contains the instance UUID and hostname; if no
  hostname is set, SmartOS falls back to the alias, then the UUID
- [vendor-data][vendor-data]: populated from
  `internal_metadata['cloud-init:vendor-data']`, which is reserved for SmartOS
  or Triton-supplied defaults that users may override with
  `customer_metadata['cloud-init:user-data']`
- [network-config][network-config]: populated from
  `customer_metadata['cloud-init:network-config']` if that is set, otherwise
  generated automatically from the instance's `nics` and `resolvers` metadata

On instance startup, SmartOS rebuilds this filesystem if the source metadata has
changed, for example after adding a NIC or changing the hostname.

Instances created from NoCloud-compatible images do not include the mdata tools
by default; install them separately if needed.

Examples of SmartOS payloads and image build scripts are available in the
[triton-nocloud-images][triton-nocloud-images] repository.

[smartos-20260306T044811Z]: https://us-central.manta.mnx.io/Joyent_Dev/public/SmartOS/smartos.html#20260306T044811Z
[nocloud]: https://docs.cloud-init.io/en/latest/reference/datasources/nocloud.html#nocloud
[user-data]: https://docs.cloud-init.io/en/latest/reference/datasources/nocloud.html#user-data
[meta-data]: https://docs.cloud-init.io/en/latest/reference/datasources/nocloud.html#meta-data
[vendor-data]: https://docs.cloud-init.io/en/latest/reference/datasources/nocloud.html#vendor-data
[network-config]: https://docs.cloud-init.io/en/latest/reference/datasources/nocloud.html#network-config
[triton-nocloud-images]: https://github.com/TritonDataCenter/triton-nocloud-images/tree/main/examples
