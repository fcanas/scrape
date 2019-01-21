# scrape

Download HLS streams

```
usage: scrape [-p] [-v] input_url output_url
  input_url     a remote URL to an m3u8 HLS playlist
  output_url    a local path where the HLS stream should be saved
  -p            download only playlist files
  -v            verbose output
```

## _Caveat Emptor_

Scrape only vaguely works. You'd be crazy to want to use it.

* It attempts to download several resources simultaneously. This tends to fail for a 
  variety of reasons. It works best for short HLS streams with few variants.
* It doesn't reload playlists. That means for live streams, it will only download a 
  snapshot of resources that are exposed at the point in time a playlist is fetched.
* It preserves directory structure, which is sometimes good, and sometimes catastrophic. 
  Cross-domain resources are especially problematic.
* It reports progress by telling you what is downloaded, nothing about what remains.
* It doesn't let you select a variant. It's all or nothing.
* It doesn't retry on failure.
