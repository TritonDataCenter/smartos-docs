# Using CfEngine

[CfEngine](https://cfengine.com/) is considered by many to be the grandfather
of configuration management systems. CfEngine is written in C and therefore
has far fewer dependencies than other configuration management systems, and
explicitly lists SmartOS as a supported operating system.

CfEngine uses a declarative, orderless syntax written in "promises". If you
are unfamiliar with cfengine, see the [CfEngine Primer][cf-primer].

[cf-primer]: https://zonename.org/cf-primer/

CfEngine can be installed via pkgsrc.

    pkgin install cfengine

To target SmartOS, use the `smartos::` context. Additional context keys for
SmartOS and Triton are available from the [smartos-metadata module][md_mod].

[md_mod]: https://github.com/bahamat/cfengine-smartos-metadata

## Resources

- [CfEngine Home](https://cfengine.com/)
- [CfEngine Documentation](https://docs.cfengine.com/)
- [CfEngine Reference](https://docs.cfengine.com/docs/3.21/reference.html)
