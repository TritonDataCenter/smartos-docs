# Using Ansible

Because Ansible is agentless and the only requirement is python, it works
surprisingly well. For non-global zones, ansible works "out of the box".

## Ansible in the Global Zone

For the Global Zone you need to have `python` installed via
[pkgsrc](working-with-packages.md) and in your inventory file you need to set
`ansible_python_interpreter` to `/opt/tools/bin/python`.

    my-smartos-cn    ansible_user=root    ansible_host=198.51.100.37    ansible_python_interpreter=/opt/tools/bin/python

You can either ssh to your SmartOS host and install python manually or install
python via ansible using the `raw` module.

    ansible my-smartos-cn -m raw -a 'pkgin -y in python311'

Ansible has some SmartOS Global Zone specific modules:

- [imgadm](https://docs.ansible.com/ansible/latest/collections/community/general/imgadm_module.html)
- [vmadm](https://docs.ansible.com/ansible/latest/collections/community/general/vmadm_module.html)
- [nictagadm](https://docs.ansible.com/ansible/latest/collections/community/general/nictagadm_module.html)

Once that is done, you may write playbooks and run playbooks. There are
examples in the module documentation and on the module author's blog at:

- [Running Ansible in the SmartOS global zone][ansible-gz]
- [Ansible modules for SmartOS imgadm and vmadm][ansible-imgadm-vmadm]

[ansible-gz]: https://blog.jasper.la/posts/running-ansible-in-the-smartos-global-zone/
[ansible-imgadm-vmadm]: https://blog.jasper.la/posts/ansible-modules-for-smartos-imgadm-and-vmadm/

Thanks to Jasper Lievisse Adriaanse for writing and sharing these
modules!

## References

- [Ansible Documentation Home](https://docs.ansible.com/ansible/latest/index.html)
- [Ansible Module Reference](https://docs.ansible.com/ansible/latest/collections/index_module.html)
