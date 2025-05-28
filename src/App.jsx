import { Suspense, lazy, useEffect, useState} from 'react'
import './App.css'
import Header from './components/Header/Header'
import RouterConfig from './routes/RouterConfig'
import HeaderAndSideBar from './components/HeaderAndSideBar/HeaderAndSideBar'

const LoginPage = lazy(() => import('./pages/LoginPage/LoginPage'))

function App() {
  const [showLogin, setShowLogin] = useState(false)

  return (
    <>
      <Header />
      <HeaderAndSideBar/>
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


