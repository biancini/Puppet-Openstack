class garrstack::configs {
  
    nova_config { 'live_migration_flag':
      value => 'VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE'
    }

}