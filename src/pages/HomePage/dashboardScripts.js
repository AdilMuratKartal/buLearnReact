// THEME-JS + DOUGHNUT-JS
export function setupThemeSwitch(canvasId) { 
  const canvas = document.getElementById(canvasId);
  if (canvas) {
    canvas.height = canvas.width;
  }
  const dataSets = [[25,25,25,25]];
  const lightColors = [[
    '#66b3ff','#d1dbe7','#003366','#7193b9',
  ],[
    '#ff9999','#ffcc99','#99ff99','#99ccff',
  ],[
    '#660066','#ff6699','#ff9966','#ffcc66',
  ]];
  const darkColors  = [[
    '#813717','#2f2519','#efb375','#8e6c46',
  ]];
  const themeSwitch = document.getElementById('theme-switch');
  let isDark = localStorage.getItem('darkmode') === 'active';

  function applyMode(dark) {
    const nav = document.querySelector('nav');
    if (dark) {
      document.body.classList.add('darkmode');
      nav?.classList.replace('navbar-secondary','navbar-dark');
      //drawMultiDoughnutChart(canvasId, dataSets, darkColors, '#000');
      drawMultiDoughnutChart2(canvasId, dataSets, darkColors,"black",true);
      localStorage.setItem('darkmode','active');
    } else {
      document.body.classList.remove('darkmode');
      nav?.classList.replace('navbar-dark','navbar-secondary');
      //drawMultiDoughnutChart(canvasId, dataSets, lightColors, '#fff');
      drawMultiDoughnutChart2(canvasId, dataSets, lightColors,"white",false);
      localStorage.setItem('darkmode','');
    }

  }

  themeSwitch?.addEventListener('click', () => {
    isDark = !isDark;
    applyMode(isDark);
  });

  // initialize
  applyMode(isDark);
}

// DOUGHNUT DRAWER (standalone)
export function drawMultiDoughnutChart(canvasId, dataSets, colors, strokeColor) {
  const canvas = document.getElementById(canvasId);
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  const maxRadius = canvas.width / 2;
  const layerCount = dataSets.length;
  const step = maxRadius / (layerCount + 1);
  let progress = 0;

  function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    let eased = 1 - Math.pow(1 - progress, 3);
    dataSets.forEach((set, i) => {
      let radius = maxRadius - i * step;
      let start = 0;
      set.forEach((val, j) => {
        let slice = (val / 100) * 2 * Math.PI * eased;
        ctx.beginPath();
        ctx.moveTo(canvas.width / 2, canvas.height / 2);
        ctx.arc(
          canvas.width / 2,
          canvas.height / 2,
          radius,
          start,
          start + slice
        );
        ctx.fillStyle = colors[i][j] || '#000';
        ctx.fill();
        ctx.closePath();
        start += slice;
      });
    });
    progress < 1 && (progress += 0.0067, requestAnimationFrame(animate));
  }
  animate();
}


export function drawMultiDoughnutChart2(canvasId, dataSets, colors, strokeColor,isDarkMode) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
        console.error("Canvas element not found:", canvasId);
        return;
    }
    
    const ctx = canvas.getContext('2d');
    if (!ctx) {
        console.error("Failed to get 2D context for:", canvasId);
        return;
    }
    
    const maxRadius = canvas.width / 2;
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const layerCount = dataSets.length;
    const layerRadiusStep = maxRadius / (layerCount + 1);
    let animationProgress = 0;
    const animationSpeed = 0.0067;

    function easeOut(t) {
        return 1 - Math.pow(1 - t, 3);
    }

    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = isDarkMode ? "#000000" : "#ffffff";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        let easedProgress = easeOut(animationProgress);

        for (let layer = 0; layer < layerCount; layer++) {
            let radius = maxRadius - layer * layerRadiusStep;
            let cutoutRadius = radius * 0.5;
            let startAngle = 0;

            for (let i = 0; i < dataSets[layer].length; i++) {
                const sliceAngle = (dataSets[layer][i] / 100) * 2 * Math.PI * easedProgress;
                ctx.beginPath();
                ctx.moveTo(centerX, centerY); 
                ctx.arc(centerX, centerY, radius, startAngle, startAngle + sliceAngle);
                ctx.lineTo(centerX, centerY);
                ctx.fillStyle = colors[layer][i] || "#000";
                ctx.fill();
                ctx.stroke();
                startAngle += sliceAngle;
                ctx.closePath();
            }

            ctx.beginPath();
            ctx.strokeStyle = strokeColor;//donut'ın dış çizgisi 
            ctx.lineWidth = 20;
            ctx.arc(centerX, centerY, cutoutRadius, 0, 2 * Math.PI);
            ctx.stroke();
            ctx.fillStyle = strokeColor;
            ctx.fill();           
        }
        
        let innerCircleRadius = (maxRadius - layerRadiusStep) * easedProgress;
        ctx.beginPath(); 
        ctx.arc(centerX, centerY, innerCircleRadius, 0 , 2 * Math.PI);
        ctx.fillStyle = "#4e4c4d";
        ctx.fill();

        let animatedNumber = Math.floor(easedProgress * 100);
        ctx.fillStyle = `rgba(255, 255, 255, ${easedProgress})`;
        ctx.font = `${Math.floor(30 * easedProgress)}px Arial`;
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.fillText('%' + animatedNumber, centerX, centerY);

        if (animationProgress < 1) {
            animationProgress += animationSpeed;
            requestAnimationFrame(animate);
        } else {
            animationProgress = 1;
        }
    }

    animate();
}


