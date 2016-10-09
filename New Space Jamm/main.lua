 -- Space Jamm 2.0
 -- Universidade do Estatod do Rio de Janeiro - UERJ
 -- Lucas Lira e Caio Saud
  
  function love.load()
  
 	-- BMG's and Images
 	-- BMG's, Images and Sounds
  	bmg = love.audio.newSource("SimpleBeat.mp3", "stream", true )
  	bmg:play()
  	winbmg = love.audio.newSource("Stepping.mp3", "stream", true )
  	bulletimg = love.graphics.newImage ('LaserBlue.png')
  	background = love.graphics.newImage('Back_Ground.jpg')
  	winning = love.graphics.newImage('Won.png')
 	
 	--Nome: 'love.graphics'
 	--Propriedade: sintaxe
 	--Tempo de Linkagem: Compilação
 	--Explicação: O modulo graphics é chamado em tempo de compilação a fim de ser responsável pelo desenho de linhas, imagens
 	-- textos ou objetos na tela. 
 	explosionimg = love.graphics.newImage('explosion.png')
 	lasersound = love.audio.newSource ("laser1.wav", "stream", true )
 	explosionsound = love.audio.newSource ("explosion.wav", "stream", true) 
 
  
  	--Game States
  	gameOver=false
  	gameWon=false
  	canMove=true
  	score=0
 	
 	level=1
 	--Window Dimensions
  	winw = love.graphics.getWidth()
  	winh = love.graphics.getHeight()
 
 	--Create Player
 	player = {}
 
 	player.image = love.graphics.newImage('PlayerShip.png')
 	player.w, player.h = 32
  	player.x = winw / 2 - player.w
  	player.y = winh - 50
  	player.speed = 300
 	
 	--Nome: '/'
 	--Propriedade: Semântica
 	--Tempo de Linkagem: Compilação
 	--Explicação: O operador '/' será definido quanto ao sua finalidade em tempo de compilação de acordo com a lingugem.
  
  	--Create Enemies
  	enemies = {}
 
 	for j = 0, 1 do
 		for i = 0, 7 do
 			enemy = {}
 			enemy.image = love.graphics.newImage('EnemyShip.png')
 			enemy.w = 32
 			enemy.h = 32
 			enemy.x = i * (enemy.w + 60) + 100
 			enemy.y = j * (enemy.h + 100) + 100
 			enemy.speed = 60
 			table.insert(enemies, enemy)
  			enemy.right = true
  		end
  	end
 	
 	
 
  	--Creating collision rectangle for left side
  	colrectL = {}
  	colrectL.x = -10
 	colrectL.y = 0
 	colrectL.w = 10
 	colrectL.h = 600
 	colrectL.mode = "fill"
 
 	--creating collision rectangle for right side
 	colrectR = {}
 	colrectR.x = winw + 1
 	colrectR.y = 0
 	colrectR.w = 10
 	colrectR.h = 600
 	colrectR.mode = "fill"
  
  	--Create Bullets
  	bullets = {}
 
 	--Create Explosions
 	explosion = {}
 
 	--Explosion Timer
 	canErase = false
 	canEraseTimerMax = 2
 	canEraseTimer = canEraseTimerMax
 
 	--Bullet Timer
 	canShoot = true
 	canShootTimerMax = 0.5 --0.9 = perfect speed || lower speeds = faster shooting
 	canShootTimerMax = 0.9 --0.9 = perfect speed || lower speeds = faster shooting
 	shootSpeed = 400
 	canShootTimer = canShootTimerMax
  end
 
 function love.update(dt)
 
 	--can shoot?
  	canShootTimer = canShootTimer - (1 * dt)
  	if canShootTimer < 0 then canShoot = true end
  
 	--can erase explosion?
 	canEraseTimer = canEraseTimer - (1 * dt)
 	if canEraseTimer < 0 then canErase = true end
 
  	 --boundaries and movement for player
  	if canMove and love.keyboard.isDown("right") and player.x + player.w <= winw then player.x = player.x + player.speed * dt; end
  
     if canMove and love.keyboard.isDown("left") and player.x >= 0 then player.x = player.x - player.speed * dt; end
 
     --Create bullets when z or space is pressed 
      if love.keyboard.isDown(' ', 'z') and canShoot then
  	newBullet = { x = player.x + (player.image:getWidth()/2), y = player.y, img = bulletImg }
  	table.insert(bullets, newBullet)
 	lasersound: play()
  	canShoot = false
  	canShootTimer = canShootTimerMax
  	end
 	
 	--Nome: 'newBullet'
 	--Propriedade: Variável
 	--Tempo de Linkagem: Execução
 	--Explicação: A variável 'newBullet' tem seu valor determinado em tempo de execução, pois depende de valores funcionais que
 	--respondem a interações do usuário.
 
  
  -- Boundaries for Enemies
  
 	--Enemy Loop
 	 for i,v in ipairs(enemies) do
     	--Colision Check (w/ Rectangles)
   		if v.x < colrectR.x + colrectR.w and colrectR.x < v.x + v.w and v.y < colrectR.y + colrectR.h and colrectR.y < v.y + v.h then
 			enemy.right = false
 		end
   		if v.x < colrectL.x + colrectL.w and colrectL.x < v.x + v.w and v.y < colrectL.y + colrectL.h and colrectL.y < v.y + v.h then
 			enemy.right = true
 		end
 
 	--Moving AI_Enemies (if true = move right / if false = move left)
 		if enemy.right then v.x = v.x + enemy.speed * dt end
 
 		if enemy.right == false then v.x = v.x - enemy.speed * dt end
 	end
 
  	--Update bullets positions
  	for i, bullet in ipairs(bullets) do
  		bullet.y = bullet.y - (shootSpeed * dt)
		
	--Nome: 'for'
 	--Propriedade: sintaxe
 	--Tempo de Linkagem: Design
 	--Explicação: O bloco 'for' é definido no design da linguagem sendo uma palavra reservada de classificação 'loop'.
 
  
    		if bullet.y < 0 then -- Remove Bullets (Off the screen)
  			table.remove(bullets, i)
 		end
 	end
 
 	--Bullet Collision logic loop
      for i, enemy in ipairs(enemies) do
  		for j, bullet in ipairs(bullets) do
  			if CheckCollision(enemy.x, enemy.y, enemy.image:getWidth(), enemy.image:getHeight(), bullet.x, bullet.y, bulletimg:getWidth(), bulletimg:getHeight()) then
 				newExplosion = { x = enemy.x, y = enemy.y, img = explosionimg }
 				table.insert(explosion, newExplosion)
 				explosionsound: play()
 				canEraseTimer = canEraseTimer - (1 * dt)
 				if canErase == true then
 					for k, explod in ipairs (explosion) do
 					table.remove(explosion, k)
 					canErase = false
 					end
 				end
  				table.remove(bullets, j)
  				table.remove(enemies, i)
 				score = score + 131
 				if level == 1 then
 					score = score + 131
 				end
 				if level == 2 then
 					score = score + 262
 				end
  			end
  		end
  	end
 	--Nome: 'table.remove(enemies, i)'
 	--Propriedade: Tabela (remove)
 	--Tempo de Linkagem: Execução
 	--Explicação: A remoção da tabela é definida em tempo de execução, pois depende da interação do usuário com as demais
 	--regras do programa.
  
  	if not next(enemies) then
 		level = level +1
 		for j = 0, 2 do
 			for i = 0, 7 do
 				enemy = {}
 				enemy.image = love.graphics.newImage('UFO.png')
 				enemy.w = 32
 				enemy.h = 32
 				enemy.x = i * (enemy.w + 60) + 100
 				enemy.y = j * (enemy.h + 100) + 100
 				enemy.speed = 65
 				table.insert(enemies, enemy)
 				enemy.right = true
 			end
 		end
  			for i, bullet in ipairs(bullets) do
  				table.remove(bullets)
  				canShoot = false
 				canMove = false
  				canShootTimer = canShootTimerMax
  			end
 						
 		if level == 3 then
  			gameWon = true
 			
 		end
  	end
  end
  
 function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
   return x1 < x2+w2 and
          x2 < x1+w1 and
          y1 < y2+h2 and
          y2 < y1+h1
 end
 
 function love.draw()
 		--Drawing background
 		love.graphics.draw(background)
 	
 		--Drawing player
 		love.graphics.draw(player.image, player.x, player.y)
 	
 	
 		--Collision rectangles
 		love.graphics.rectangle(colrectR.mode, colrectR.x, colrectR.y, colrectR.w, colrectR.h)
 		love.graphics.rectangle(colrectL.mode, colrectL.x, colrectL.y, colrectL.w, colrectL.h)
 
 		--drawing bullets
 		for i, bullet in ipairs(bullets) do
    		love.graphics.draw(bulletimg, bullet.x, bullet.y)
  		end
  
 		for i,v in ipairs(explosion) do
 			love.graphics.draw(explosionimg, v.x, v.y, v.width, v.height)
 		end
 
  		--drawing enemies
  		for i,v in ipairs(enemies) do
      		love.graphics.draw(enemy.image, v.x, v.y, v.width, v.height)
  		end
  		love.graphics.print("Score: " .. score, 10, 5)
 		love.graphics.print("LEVEL: " .. level, 300, 5)
  
  		--Checking for GameOver
  	if gameWon == true then
  		bmg:stop()
  		winbmg:play()
  		winbmg:setVolume(0.1)
  		love.graphics.draw(winning, 0, 0)
 		
 	--Nome: 'if'
 	--Propriedade: sintaxe
 	--Tempo de Linkagem: Design
 	--Explicação: O bloco 'if' é definido no design da linguagem sendo uma palavra reservada de classificação 'condition'.
 
  	end 
  end