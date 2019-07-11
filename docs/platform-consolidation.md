# Platform Consolidation

## Motivation

### History

Once upon a time Smart Data Center (SDC) was still closed source. Back
then it made a lot of sense to segregate open source SmartOS
functionality from closed source SDC functionality.
The differences between the two can be seen in the differences between
the [sample SmartOS build configuration](https://github.com/joyent/smartos-live/blob/master/sample.configure.smartos)
and the [sample SDC platform build configuration](https://github.com/joyent/smartos-live/blob/master/sample.configure.sdc)
and the git repositories they reference.

Now that SDC is open source, the main reason for having separate builds
(protecting proprietary source code) has disappeared.

### Benefits

Some of the benefits of platform consolidation

1. No need to duplicate code between the smartos-overlay and
    sdc-related repostories (e.g.
    [FWAPI-107](https://smartos.org/bugview/FWAPI-107))
2. People who want to test bleeding edge SmartOS builds could simply
    use builds created by Joyent's Jenkins instance
3. SmartOS builds get subjected to the CI tests (currently that is only
    true for SDC platform images)

## Implementation

There is a bootparam passed in by grub on SmartOS media ("smartos=true")
that is not passed in to SDC nodes.
The simple solution is to make the SDC platform image behave like
SmartOS when it sees that bootparam.

### Phases

1. Get SDC platform images behaving like SmartOS when the
    "smartos=true" bootparam is present
    1. Verify that this doesn't have any negative effects on SDC

2. Flag day - deprecate smartos-overlay repo in a way that will fail
    noisily for people still building against it.
    1. remove old sample.configure.smartos file

3. Consolidate build process (Mountain Gorilla)

[Github issue for the first
phase](https://github.com/joyent/sdc-platform/issues/3)
