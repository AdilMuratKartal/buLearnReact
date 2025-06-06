import React from 'react'
import Home from '../pages/HomePage/HomePage'
import Courses from '../pages/CoursesPage/Courses'
import Grades from '../pages/GradesPage/Grades'
import Calendar from '../pages/CalendarPage/Calendar'
import CertificatesBadges from '../pages/CertificatesBadgesPage/CertificatesBadges'
import LearningPath from '../pages/LearningPathPage/LearningPath'
import Competencies from '../pages/CompetenciesPage/Competencies'
import LoginPage from '../pages/LoginPage/LoginPage'
import Account from '../pages/AccountPage/Account'
import {Routes,Route} from 'react-router-dom'


function RouterConfig() {
  return (
    <Routes>
      <Route path='/login' element={<LoginPage></LoginPage>}></Route>
      <Route path='/courses' element={<Courses/>}></Route>
      <Route path='/grades' element={<Grades/>}></Route>
      <Route path='/calendar' element={<Calendar/>}></Route>
      <Route path='/certificates-badges' element={<CertificatesBadges/>}></Route>
      <Route path='/competencies' element={<Competencies/>}></Route>
      <Route path='/learning-path' element={<LearningPath/>}></Route>
      <Route path='/account' element={<Account/>}></Route>
    </Routes>
  )
}

export default RouterConfig