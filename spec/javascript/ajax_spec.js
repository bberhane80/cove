import { ajax } from '../../app/javascript/ajax';

describe('ajax helper', () => {
  let server;

  beforeEach(() => {
    // Use sinon or a similar library for XHR mocking if available
    server = sinon.fakeServer.create();
  });

  afterEach(() => {
    server.restore();
  });

  it('makes a GET request and calls success', (done) => {
    server.respondWith('GET', '/test', [
      200,
      { 'Content-Type': 'application/json' },
      JSON.stringify({ ok: true })
    ]);

    ajax({
      url: '/test',
      method: 'GET',
      success: (response) => {
        expect(response.ok).toBe(true);
        done();
      },
      error: () => {
        fail('Should not call error');
        done();
      }
    });
    server.respond();
  });

  it('makes a POST request and calls success', (done) => {
    server.respondWith('POST', '/test', [
      201,
      { 'Content-Type': 'application/json' },
      JSON.stringify({ created: true })
    ]);

    ajax({
      url: '/test',
      method: 'POST',
      data: { foo: 'bar' },
      success: (response) => {
        expect(response.created).toBe(true);
        done();
      },
      error: () => {
        fail('Should not call error');
        done();
      }
    });
    server.respond();
  });

  it('calls error on HTTP error', (done) => {
    server.respondWith('GET', '/fail', [
      500,
      { 'Content-Type': 'application/json' },
      JSON.stringify({ error: 'fail' })
    ]);

    ajax({
      url: '/fail',
      method: 'GET',
      success: () => {
        fail('Should not call success');
        done();
      },
      error: (xhr) => {
        expect(xhr.status).toBe(500);
        done();
      }
    });
    server.respond();
  });
});
