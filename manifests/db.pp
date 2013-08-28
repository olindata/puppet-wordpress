define wordpress::db (
  $db_name,
  $db_host,
  $db_user,
  $db_password,
  $create_db,
  $create_db_user,
) {
  validate_bool($create_db,$create_db_user)
  validate_string($db_name,$db_host,$db_user,$db_password)

  ## Set up DB using puppetlabs-mysql defined type
  if $create_db {
    database { $db_name:
      charset => 'utf8',
      require => Wordpress::App[$db_name],
    }
  }
  if $create_db_user {
    database_user { "${db_user}@${db_host}":
      password_hash => mysql_password($db_password),
      require => Wordpress::App[$db_user],
    }
    database_grant { "${db_user}@${db_host}/${db_name}":
      privileges => ['all'],
      require    => Wordpress::App[$db_user],
    }
  }

}
