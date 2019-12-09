package adrianjuhl.springboot_camel_openshift_maven_archetype_process_improvement;

enum RouteInfo {
  READINESS_PROBE                                       ("direct:readinessprobe"),
  ;
  private String uri;
  RouteInfo(final String uri) {
    this.uri = uri;
  }
  public String id() {
    return this.name();
  }
  public String uri() {
    return uri;
  }
}
