module Tirantid

    # MySQL VIEW !!!!!

    # CREATE VIEW `vw_lopd_users_ambito_app`
    # AS SELECT
    #    `lus`.`usuario` AS `usuario`,
    #    `lus`.`email` AS `email`,
    #    `lam`.`nombre` AS `lopd_ambito`,
    #    `lap`.`nombre` AS `lopd_app`,
    #    `lus`.`comercial` AS `comercial`,
    #    `lus`.`grupo` AS `grupo`
    # FROM ((`lopd_users` `lus` join `lopd_ambitos` `lam` on((`lam`.`id` = `lus`.`lopd_ambito_id`))) join `lopd_apps` `lap` on((`lap`.`id` = `lam`.`lopd_app_id`))) where ((`lus`.`email` is not null) and (`lus`.`privacidad` is true));


    class VwLopdUsersAmbitoApp < TirantidBase

        self.table_name = 'vw_lopd_users_ambito_app'

        protected

        # The vw_lopd_users_ambito_app relation is a SQL view,
        # so there is no need to try to edit its records ever.
        # Doing otherwise, will result in an exception being thrown
        # by the database connection.
        def readonly?
            true
        end

    end

end