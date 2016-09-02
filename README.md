# Practicals Installer

This is a script that can be used to download and install many
practicals on a Cyber Practicals base VM.

The base VM can be downloaded from [here](https://drive.google.com/open?id=0B71VCqMfkVkTRkpRQjA0dlNwV2s).

## Available practicals

| ID  | Practical Name             | Author          |
|-----|----------------------------|-----------------|
| xss | Input Sanitisation and XSS | Alfio E. Fresta |
| otp | One-Time Pad               | Alfio E. Fresta |
| ecb | Information vs. Data       | Alfio E. Fresta |


## Usage

Login as root (via SSH or Web shell), download this project and run:

```bash
./install <practical-id> [docs-directory]
```

Where `pratical-id` is one of the IDs from the table above, and `docs-directory`
is a directory to be used to install the practical's documentation.

E.g.:

```bash
mkdir /home/student/ecb-docs/
./install ecb /home/student/ecb-docs/
```
