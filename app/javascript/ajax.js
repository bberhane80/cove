// ajax.js - Simple AJAX helper for Rails UJS and vanilla JS

// Usage: ajax({ url, method, data, success, error })
export function ajax({ url, method = 'GET', data = {}, success, error }) {
  const xhr = new XMLHttpRequest();
  xhr.open(method, url);
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  if (method !== 'GET') {
    xhr.setRequestHeader('Content-Type', 'application/json');
  }
  xhr.onload = function() {
    if (xhr.status >= 200 && xhr.status < 300) {
      if (success) success(JSON.parse(xhr.responseText));
    } else {
      if (error) error(xhr);
    }
  };
  xhr.onerror = function() {
    if (error) error(xhr);
  };
  xhr.send(method === 'GET' ? null : JSON.stringify(data));
}

// Example usage:
// ajax({
//   url: '/some/path',
//   method: 'POST',
//   data: { foo: 'bar' },
//   success: (response) => { console.log(response); },
//   error: (xhr) => { alert('AJAX error!'); }
// });
