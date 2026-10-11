---
runpage:
  required: [version]
  dependencies: [git, gem, docker, curl, ruby]
  workdir: self
---

# Bashly release checklist

Release verification for Bashly. Run this document with
[runpage](https://github.com/DannyBen/runpage):

```console :noop
BASHLY_SITE_DIR=/path/to/bashly-book \
  runpage release.md version:2.0.0
```

## Baseline

```bash Verify git is on master and clean
test "$(git branch --show-current)" = master && test -z "$(git status --porcelain)"
```

```bash Verify version in version.rb
grep -Fq "VERSION = '{{ version }}'" lib/bashly/version.rb
```

```bash Verify local gem is installed
gem list --local --exact bashly --installed --version "{{ version }}" >/dev/null
```

## RubyGems

```bash Verify published gem version
curl -fsS -o /dev/null "https://rubygems.org/gems/bashly/versions/{{ version }}"
```

## Docker

```bash Verify Dockerfile version
grep -Fq "ENV BASHLY_VERSION={{ version }}" Dockerfile
```

```bash Verify local Docker image version
docker image inspect "dannyben/bashly:{{ version }}" >/dev/null
```

## Git release

```bash Verify local Git tag
git rev-parse --quiet --verify "refs/tags/v{{ version }}" >/dev/null
```

```bash Verify changelog
grep -Fq "v{{ version }}" CHANGELOG.md
```

```bash Verify GitHub tag
curl -fsS -o /dev/null "https://github.com/bashly-framework/bashly/tree/v{{ version }}"
```

## Published release

```bash Verify remote Docker image version
docker pull "dannyben/bashly:{{ version }}" >/dev/null
```

```bash Verify GitHub release
location=$(
  curl -fsSI https://github.com/bashly-framework/bashly/releases/latest |
    tr -d '\r' |
    awk 'tolower($1) == "location:" { print $2 }' |
    tail -n 1
)
test "$location" = "https://github.com/bashly-framework/bashly/releases/tag/v{{ version }}"
```

## Documentation

```bash Verify local documentation is on master and clean
: "${BASHLY_SITE_DIR:?Set BASHLY_SITE_DIR to the local bashly-book checkout}"
test "$(git -C "$BASHLY_SITE_DIR" branch --show-current)" = master &&
  test -z "$(git -C "$BASHLY_SITE_DIR" status --porcelain)"
```

```bash Verify local documentation version
: "${BASHLY_SITE_DIR:?Set BASHLY_SITE_DIR to the local bashly-book checkout}"
ruby -ryaml -e '
  abort unless YAML.load_file(ARGV[0]).dig("branding", "label") == ARGV[1]
' "$BASHLY_SITE_DIR/retype.yml" "v{{ version }}"
```

```bash Verify remote documentation version
curl -fsS "https://raw.githubusercontent.com/bashly-framework/bashly-book/master/retype.yml" |
  grep -Fq "label: v{{ version }}"
```
