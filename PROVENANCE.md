# Provenance (zero-cost)

- Use GPG-signed commits and **signed tags** for releases.
- Keep masters private; publish only low-res watermarked previews.
- Hash assets:
  - /book/hash.txt = SHA256 of the current PDF.
  - /assets/public-previews/MANIFEST.json = filename + SHA256 + commit + date.
- Mirror each GitHub Release to a free archive (e.g., Zenodo) for extra timestamps.
