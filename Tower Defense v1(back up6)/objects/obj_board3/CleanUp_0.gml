// Clean up surface when object is destroyed
if (surface_exists(content_surface)) {
    surface_free(content_surface);
}
