# Giving Windows VMs more processors

## The Problem

> I am working on porting some VMs from ESXi over to SmartOS and had
> encountered a problem. One of the VMs in ESXi is a Windows 7 machine
> with 4 cores. When I created the VM in SmartOS, I specified "vcpus:
> 4", but then upon booting the VM it did not appear to have 4 cores.
>
> It turns out that SmartOS/qemu sets up the VM to have 4 individual CPU
> sockets when you specify vcpus: 4, not 4 cores, and although Windows
> allows many CPU cores, it has seemingly arbitrary limits on CPU
> sockets like:
>
> - Windows 7 Home Premium: 1
> - Windows 7 Professional: 2
> - Windows 8: 2
> - Windows Small Business Server 2003: 2
> - Windows Server 2012 Foundation: 1
> - Windows Server 2012 Essentials: 2
> - Windows Server 2012 Standard: 64
> - Windows Server 2012 Datacenter: 64
>
> My SmartOS server is running a Xeon E3-1230 v3 processor which is one
> processor with 4 cores, and with hyperthreading normally shows up as 8
> virtual processors if one was to run Windows on this processor, bare
> metal.
>
> I want my Windows VM to be able to run 4 virtual processors, but the
> only way you can run Windows with 4 CPU sockets is to run with the
> full Windows Server packages, which in my use case is overkill and my
> applications aren't even supported on Windows Server.

## The Solution

1. Shut down the vm
2. Update the value of `vcpus` to 1. (this will stop smartos from passing
   `-smp` option to QEMU)
3. Add `-smp threads=4` to your `qemu_extra_opts`
4. (Optional) Adjust cpu shares / caps accordingly
5. Boot the VM

## References

- <http://www.listbox.com/member/archive/184463/entry/3:4/20130601215257:23745FBE-CB27-11E2-8F84-A9A1ECB30199/>
- <http://www.listbox.com/member/archive/184463/entry/5:7/20140227135143:48D355CE-9FE0-11E3-93AD-BFC6E879A3B9/>
- <http://www.listbox.com/member/archive/184463/entry/4:7/20140227140833:89AFB540-9FE2-11E3-828B-F6780513CEF7/>
