# Using Ansible

Ansible has two SmartOS specific modules:

- [imgadm](http://docs.ansible.com/ansible/latest/imgadm_module.html)
- [vmadm](http://docs.ansible.com/ansible/latest/vmadm_module.html)

To run these you need python 2 in the global zone. This doesn't exist on
SmartOS, so an easy way is to use pkgsrc to install it. See the
instructions on the
["64-bit tools (SmartOS GZ)"](https://pkgsrc.joyent.com/install-on-illumos/)
tab at <https://pkgsrc.joyent.com> for doing this.

Once that is done, you may write plays using the 2 modules. There are
examples in the module documentation and on the module author's blog at:

- [Running Ansible in the SmartOS global zone][ansible-gz]
- [Ansible modules for SmartOS imgadm and vmadm][ansible-imgadm-vmadm]

[ansible-gz]: https://blog.jasper.la/posts/running-ansible-in-the-smartos-global-zone/
[ansible-imgadm-vmadm]: https://blog.jasper.la/posts/ansible-modules-for-smartos-imgadm-and-vmadm/

Thanks to Jasper Lievisse Adriaanse for writing and sharing these
modules!
