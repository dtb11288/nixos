final: prev: {
  chromium = prev.ungoogled-chromium.override { enableWideVine = true; };
}
