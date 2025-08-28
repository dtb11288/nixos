final: prev: {
   osm-gps-map = prev.osm-gps-map.overrideAttrs (o: {
     nativeBuildInputs = (o.nativeBuildInputs or []) ++ [final.autoreconfHook final.gtk-doc];
   });
}
