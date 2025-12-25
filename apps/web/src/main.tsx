import React from 'react'
import ReactDOM from 'react-dom/client'

function App() {
  return (
    <div style={{fontFamily:'system-ui', padding:24}}>
      <h1>SIBU Web</h1>
      <p>Front separado. API bajo /api.</p>
      <ul>
        <li><a href="/api/auth/docs">Auth Swagger</a></li>
        <li><a href="/api/users/docs">Users Swagger</a></li>
        <li><a href="/api/cases/docs">Cases Swagger</a></li>
      </ul>
    </div>
  )
}
ReactDOM.createRoot(document.getElementById('root')!).render(<React.StrictMode><App/></React.StrictMode>)
