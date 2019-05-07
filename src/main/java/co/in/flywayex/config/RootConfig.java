package co.in.flywayex.config;

import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.orm.hibernate5.HibernateTransactionManager;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Configuration
@EnableWebMvc
@ComponentScan("co.in.flywayex.config")
@PropertySource("classpath:db.properties")
public class RootConfig {

	@Autowired
	private Environment environment;

	@Bean
	public DataSource portalDataSource() {

		final BasicDataSource basicDataSource = new BasicDataSource();
		basicDataSource.setDriverClassName(environment.getProperty("db.driver"));
		basicDataSource.setUrl(environment.getProperty("db.url"));
		basicDataSource.setUsername(environment.getProperty("db.username"));
		basicDataSource.setPassword(environment.getProperty("db.password"));
		return basicDataSource;

	}

	@Bean
	@DependsOn("flyway")
	public LocalSessionFactoryBean localSessionFactoryBean() {

		final LocalSessionFactoryBean factoryBean = new LocalSessionFactoryBean();
		factoryBean.setDataSource(portalDataSource());

		final Properties properties = new Properties();
		properties.setProperty("hibernate.show_sql", environment.getProperty("hibernate.show_sql"));
		properties.setProperty("hibernate.format_sql", environment.getProperty("hibernate.format_sql"));
		properties.setProperty("hibernate.hbm2ddl.auto", environment.getProperty("hibernate.hbm2ddl.auto"));
		properties.setProperty("hibernate.dialect", environment.getProperty("hibernate.dialect"));

		factoryBean.setHibernateProperties(properties);
		// factoryBean.setAnnotatedClasses(null);
		return factoryBean;
	}

	@Autowired
	@Bean
	public HibernateTransactionManager transactionManager() {

		final HibernateTransactionManager manager = new HibernateTransactionManager();
		manager.setSessionFactory(localSessionFactoryBean().getObject());
		return manager;

	}

	@Bean(initMethod = "migrate")
	public Flyway flyway() {

		final Flyway flyway = new Flyway();
		flyway.setBaselineOnMigrate(true);
		flyway.setDataSource(portalDataSource());
		flyway.setLocations("classpath:/migration");
		return flyway;
	}

}
