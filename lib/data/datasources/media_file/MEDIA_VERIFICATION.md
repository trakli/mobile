# Media layer verification

## Current architecture (after recent changes)

- **Domain:** `MediaRepository` (getFileContent, addMediaToTransaction, getMediaForTransaction, deleteMediaByPath), `MediaFileEntity`, use cases (GetFileContent, AddMediaToTransaction, GetMediaForTransaction, DeleteMedia).
- **Data – local:** `MediaFileLocalDataSource`: insertMediaForTransaction, getByPath, getForTransaction, deleteByPath. All DB access for media goes through this.
- **Data – remote:** `MediaFileRemoteDataSource`: getAllMediaFiles (returns []), getMediaFile (returns null), getFileContent(id). Delete uses transaction API only.
- **Data – repository:** `MediaRepositoryImpl` uses local DS for all DB ops; getFileContent does cache-in-repo (file_$id.$ext); post/delete go through sync.
- **Sync:** `MediaSyncHandler`: restPutRemote → transaction API add media + upsertLocal(dto); restDeleteRemote → transaction API delete media + upsertLocal(dto). restGetAllRemote/restGetRemote are no-ops (media comes with transactions).

## What to remove

1. **`MediaFileLocalDataSource.insertOne(MediaFile media)`** – Unused. The repository only uses `insertMediaForTransaction`. No caller uses `insertOne`. Safe to remove from abstract and impl.

## What could be improved (optional)

1. **Cache key:** Keep `file_$id.$ext` unless you add path-based lookup; then consider path-based cache key with safe path handling.
2. **File cache location:** Cache logic could be moved to a small helper or a “cache” method on a local cache abstraction; current in-repo logic is fine.
3. **Remote datasource:** `getAllMediaFiles` and `getMediaFile` are required by the sync handler interface but always return empty/null. Leave as-is; media is only fetched with transactions.

## Summary

- Remove: `insertOne` from `MediaFileLocalDataSource`.
- No other dead code or required removals found. Optional improvements above are non-blocking.
