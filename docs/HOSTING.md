# Download hosting

Public installers and release files live on `https://tools.simplehelp.io`.
The product hub is `https://simple-help.com/tools`; guides are
`https://simple-help.com/tools/vmrelay` and
`https://simple-help.com/tools/agent-sudo`. No new product landing page is
published on the tools host.

## VMRelay

Install with:

```bash
curl -fsSL https://tools.simplehelp.io/vmrelay/install.sh | bash
```

The bootstrap selects macOS or Linux, amd64 or arm64, downloads a versioned
archive and verifies its embedded SHA-256 before extraction or installation.
`VMRELAY_INSTALL_DIR` overrides the default `/usr/local/bin`. A writable
destination needs no sudo; other destinations use the existing sudo prompt.

The initial hosted version is 0.2.53. These are the original GitHub release
bytes, without rebuilding or changing their original licence terms:

| Path below `/vmrelay/0.2.53/` | SHA-256 |
| --- | --- |
| `vmrelay_darwin_amd64.tar.gz` | `87490766b9672d4443d1df3368254d048d2e223b64771a439400cde39dac8c9f` |
| `vmrelay_darwin_arm64.tar.gz` | `2d4a10c8b5eba8012284a0e010bdfb655f9d31e6e4c248d16ffec1616ff66286` |
| `vmrelay_linux_amd64.tar.gz` | `9f7246c00037daca133f8e5625334e9e8b7511d14a2a2e196f26f246212c8d23` |
| `vmrelay_linux_arm64.tar.gz` | `e713f4ee7eb46a3c71fd9ca404ee23d145fca139ddb92bafa0217b24bf9ce346` |
| `checksums.txt` | `fa6f23da829e6e54d8f0bb1cca3f503065837ae74adb90a4bcd9c4e77d58212a` |

`/vmrelay/latest.json` carries the updater's release metadata, using
the existing `tag_name` and `html_url` fields. Its initial value identifies
0.2.53 and `https://simple-help.com/tools/vmrelay`.

Installed 0.2.53 binaries still check GitHub and run the GitHub-hosted
installer. Hosting the files alone does not change them. Release 0.2.54 changes both the update-check endpoint and the install
command to tools.simplehelp.io. It is also published through the existing
GitHub update path, so older installations can discover it.

## Publication ordering

1. Build and test a new version, including the current licence and notices.
   Never overwrite a versioned archive with rebuilt bytes.
2. Publish versioned archives and checksums, then anonymously download and
   verify every file against the release hashes.
3. Update the bootstrap's version and pinned hashes, test it, and publish it
   under a freshly checked previous-file hash.
4. Update `latest.json` last, under its previous-file hash, once the
   bootstrap installs the advertised version.
5. Verify the real public bootstrap in an isolated writable directory and
   record public URLs, hashes and results. Do not install on production or
   development hosts as part of this check.

Use the existing tools publishing service. Existing-file updates require
the live SHA-256 as a precondition. Retain older versioned files and GitHub
release assets for existing links and rollback. Release metadata must not
advertise a version before its files and installer are available.

## agent-sudo

The existing bootstrap stays at
`https://tools.simplehelp.io/agent-sudo/install.sh`; versioned 1.0.3 and
historical download files keep their existing URLs and bytes. No
agent-sudo binary or grant change is needed for this hosting work.

The former `/agent-sudo.html` product page now forwards to the new guide.
Version 1.0.3 prints that historical URL in terminal handoffs and
help; release 1.0.4 points to `https://simple-help.com/tools/agent-sudo`.
Existing installed binaries retain the historical URL until a new release
is installed. Do not change frozen release artifacts to alter it.
The forwarding source is `../agent-sudo/website/agent-sudo-redirect.html`.
This preserves links printed by existing binaries. The service cannot delete files; literal URL
removal would require the hosting operator.

See the sibling agent-sudo repository's `docs/PUBLISHING.md` for its
installer, artifact and privilege validation procedure.

## Hosting validation — 2026-11-16

All four original 0.2.53 archives and checksums were downloaded from their
public tools.simplehelp.io URLs and matched the table above. The live
`latest.json` identifies v0.2.53 and the SimpleHelp guide. The hosted
bootstrap matched the reviewed source and installed the exact Linux amd64
release into an isolated writable directory without sudo; `--version`
reported 0.2.53. Four platform selections and five failure cases passed
local installer fixtures. Go tests/vet and agent-sudo tests/clippy passed.
The forwarding page was independently verified as exact HTML content, and
the existing agent-sudo installer and five release downloads retained their
hashes. No new binary release was made during hosting migration.

## 0.2.54 release — 2026-11-16

Version 0.2.54 ships the tools-host updater and SimpleHelp guide links. Each
macOS/Linux amd64/arm64 archive contains LICENSE, NOTICE and
THIRD_PARTY_NOTICES.txt. Binaries were built with Go 1.27.4, whose downloaded
toolchain archive was verified against the official SHA-256. Go tests/vet,
four archive/licence inspections, nine installer platform/failure fixtures
and a secret scan of the release commit passed.

All versioned public files were anonymously downloaded and verified before
the pinned bootstrap update. The actual public bootstrap installed the exact
Linux amd64 0.2.54 release binary into an isolated writable directory without
sudo; help points to the public SimpleHelp guide.

| Path below `/vmrelay/0.2.54/` | SHA-256 |
| --- | --- |
| `vmrelay_darwin_amd64.tar.gz` | `93338d87fd135141b2a4db3e75af2ac6e7aa4393c1933102dffdf548c5b0adf5` |
| `vmrelay_darwin_arm64.tar.gz` | `5d0b8403e399a28090f0efb3990caadd91fb5ee0407f6bce8aa580df6e4a990b` |
| `vmrelay_linux_amd64.tar.gz` | `1f26518346f48b192d5c818a298625c7d6bfd72653b17d962f34f15af98498f3` |
| `vmrelay_linux_arm64.tar.gz` | `281e3286042ad690c2b00f48e8b1b0530b003b0e23f02f8ca5ec10534bd6f43e` |

Bootstrap SHA-256: `43c9376cfd0467245111ed23959e2ca6c9bffe92e68d47a1b67b19d6c20bca19`.

The GitHub release mirrors the same five files so installed 0.2.53 clients
can discover the migration. Older versioned downloads remain unchanged.

The live latest.json identifies v0.2.54 and the SimpleHelp guide. Seven
sanitized hosting receipts, exact public hashes, GitHub mirror digests and
installation evidence are preserved in [the release record](releases/0.2.54.json).
