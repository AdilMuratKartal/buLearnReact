import { Suspense, lazy, useEffect, useState} from 'react'
import './App.css'
import RouterConfig from './routes/RouterConfig'
import MainLayout from './Layout/MainLayout'

const LoginPage = lazy(() => import('./pages/LoginPage/LoginPage'))

function App() {
  const [showLogin, setShowLogin] = useState(false)

  return (
    <>
      <MainLayout />
      {showLogin && (
        <Suspense fallback={<div>Loading...</div>}>
          <LoginPage />
        </Suspense>
      )}
      <RouterConfig></RouterConfig>
    </>
  )
}

export default App


