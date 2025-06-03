import React,{ useEffect } from 'react';
import './HomePage.css'
import {
  setupThemeSwitch,
  drawMultiDoughnutChart,
  initializeCalendar,
} from './dashboardScripts';
import CourseIcon from '../../components/CourseIconSvg/CourseIcon';
import KeyboardArrowRightIcon from "@mui/icons-material/KeyboardArrowRight";
import KeyboardArrowLeftIcon from '@mui/icons-material/KeyboardArrowLeft';
import { useSelector,useDispatch } from 'react-redux';
import CertificateImage from '../../assets/images/certificate_badges.png';
import LearningPathImage from '../../assets/images/learning_path.png';


function HomePage() {

  const {loading,userCourseData} = useSelector((store)=>store.user);

  useEffect(() => {
    // Initialize all dashboard behaviors from external file
    setupThemeSwitch('doughnutChart');
    initializeCalendar(
      'calendar-current-date',
      'calendar-dates',
      'calendar-prev',
      'calendar-next'
    );
    // Initial draw of the doughnut chart (light mode)
  }, []);

  const lineBarColors = 
  [
    '#5EB344',
    '#FCB72A',
    '#F8821A',
    '#E0393E',
    '#963D97',
    '#069CDB',
  ]

  const CourseCardColors = 
  [
    'gray',
    'green',
    'lightgreen',
    'orange',
    'blue',
    'red',
  ]
  
  return (
    <> 
      {/* Dashboard */}
      <div className="dashboard-container">
        <div className="dashboard">
          {/* Card1 */}
          <div className="card">
            <div className="card-head">
              <h2 id="user-name">Burhan Günay</h2>
              <a href="#" className="cards-link">
                Profile Git
                <KeyboardArrowRightIcon sx={{ fontSize: "30px", fontWeight: "bold"}} />
              </a>
            </div>
            <div className="user-img-container">
              <img
                src="https://cdn3.pixelcut.app/7/20/uncrop_hero_bdf08a8ca6.jpg"
                alt="Kullanıcı Resmi"
                className="user-img"
              />
            </div>
          </div>

          {/* Card2 */}
          <div className="card">
            <div className="card-head">
              <h2>Kurslarım</h2>
              <a href="#" className="cards-link">
                Kurslara Git
                <KeyboardArrowRightIcon sx={{ fontSize: "30px", fontWeight: "bold"}} />
              </a>
            </div>

            {/* Courses List */}
            <div className="courses dashboard" id="courses">

              {
                userCourseData && userCourseData.map((course,index) =>(
                  <div key={index} className={`course ${CourseCardColors[index]}`}>
                    <a href="#" className="coursecard-link">
                      <div className="course-icon">
                        {/* SVG Icon */}
                        <CourseIcon></CourseIcon>
                      </div>
                      <div className="course-text">{course.Course}</div>
                    </a>
                  </div>
                ))
              }



            </div>
          </div>

          {/* Card3 */}
          <div className="card">
            <div className="card-head">
              <h2>Notlarım</h2>
              <a href="#" className="cards-link">
                Notlarıma Git
                <KeyboardArrowRightIcon sx={{ fontSize: "30px", fontWeight: "bold"}} />
              </a>
            </div>
            
            {/* Bar Chart */}
            <div className="simple-bar-chart">
              {
                userCourseData && userCourseData.map((course,index) => (
                  <div
                      key={index}
                      className="item"
                      style={{ '--clr': lineBarColors[index], '--val': String(Math.floor(course.Grade)) }}
                    >
                    <div className="label">{course.Course[0].toUpperCase()}</div>
                    <div className="value">{Math.floor(course.Grade)}%</div>
                  </div>
                ))
              }
            </div>
          </div>

          {/* Card4 */}
          <div className="card">
            <div className="card-head">
              <h2>Takvim</h2>
              <a href="#" className="cards-link">
                Takvime Git
                <KeyboardArrowRightIcon sx={{ fontSize: "30px", fontWeight: "bold"}} />
              </a>
            </div>
            <div className="calendar-container">
              <header className="calendar-header">
                {/* these IDs must match what initializeCalendar is looking for */}
                <p id="calendar-current-date" className="calendar-current-date"></p>
                <div className="calendar-navigation">
                  <KeyboardArrowLeftIcon
                    id="calendar-prev"
                    className="material-symbols-rounded" 
                    sx={{ 
                        fontSize: "30px", 
                        fontWeight: "bold",
                        '&:hover':{
                          background: "#f2f2f2",
                          borderRadius: 10
                        }
                    }} 
                  />
                  <KeyboardArrowRightIcon 
                    id="calendar-next"
                    className="material-symbols-rounded" 
                    sx={{ 
                        fontSize: "30px", 
                        fontWeight: "bold",
                        '&:hover':{
                          background: "#f2f2f2",
                          borderRadius: 10
                        }
                    }} 
                  />
                </div>
              </header>
              <div className="calendar-body">
                <ul className="calendar-weekdays">
                  {['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map(d => <li key={d}>{d}</li>)}
                </ul>
                {/* and this UL needs the matching ID too */}
                <ul id="calendar-dates" className="calendar-dates"></ul>
              </div>
            </div>
          </div>

          {/* Card5 */}
          <div className="card">
            <div className="card-head">
              <h2>Sertifika ve Rozet</h2>
              <a href="#" className="cards-link">
                Sertifikaya Git
                <KeyboardArrowRightIcon sx={{ fontSize: "30px", fontWeight: "bold"}} />
              </a>
            </div>
            <div className="card-imgcontainer">
              <img
                src={CertificateImage}
                alt="Sertifika ve Rozet"
              />
            </div>
          </div>

          {/* Card6 */}
          <div className="card">
            <div className="card-head">
              <h2>Yetkinlik</h2>
              <a href="#" className="cards-link">
                Yetkinliğe Git
                <KeyboardArrowRightIcon sx={{ fontSize: "30px", fontWeight: "bold"}} />
              </a>
            </div>
            <div className="chart-labels top">
              <span className="top-left">
                Okuma <p>%25</p>
              </span>
              <span className="top-right">
                İzleme <p>%25</p>
              </span>
            </div>
            <div className="card-doughnut-container">
              <canvas id="doughnutChart" />
            </div>
            <div className="chart-labels bottom">
              <span className="bottom-left">
                Ödev <p>%25</p>
              </span>
              <span className="bottom-right">
                Forum <p>%25</p>
              </span>
            </div>
          </div>

          {/* Card7 */}
          <div className="card full-width">
            <div className="card-head">
              <h2>Öğrenme Patikası</h2>
              <a href="#" className="cards-link">
                Öğrenme Patikasına Git
                <KeyboardArrowRightIcon sx={{ fontSize: "30px", fontWeight: "bold"}} />
              </a>
            </div>
            <div className="card-imgcontainer">
              <img
                src={LearningPathImage}
                alt="Learning Path"
              />
            </div>
          </div>

        </div>
      </div>
    </>
  );
}

export default HomePage;
