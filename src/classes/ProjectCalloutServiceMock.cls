@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock {

  global HTTPResponse respond(HTTPRequest request) {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(201);
    response.setStatus('Created');
    return response;
  }

}
