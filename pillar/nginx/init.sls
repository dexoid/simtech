# Example pillar
nginx:
  sites:
    example.com.ru:
      server_name: 'example.com www.example.com'
      socket: 'unix:/var/run/php-fpm/php-fpm.sock'

