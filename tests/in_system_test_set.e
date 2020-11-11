note
	description: "Ensuring all SCOOP Patterns are in-system for Class Context Tool exploring."
	testing: "type/manual"

class
	IN_SYSTEM_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	do_nothing_tests
			-- `do_nothing_tests'
		do
			do_nothing -- yet ...
		end

feature {NONE} -- Implementation: In-system

		-- Agent
	agent_abstract_agent_task: detachable CP_ABSTRACT_AGENT_TASK [ROUTINE]
	agent_computation: detachable CP_AGENT_COMPUTATION [ANY]
	agent_task: detachable CP_AGENT_TASK

		-- Container
	sed_container: detachable CP_SED_CONTAINER [ANY]

		-- Executor
	ex_executor: detachable CP_EXECUTOR
	ex_proxy: detachable CP_EXECUTOR_PROXY
	ex_utils: detachable CP_EXECUTOR_UTILS
	ex_future: detachable CP_FUTURE_EXECUTOR_PROXY [ANY, CP_IMPORT_STRATEGY [ANY]]

		-- Import
	imp_dynamic_type: detachable CP_DYNAMIC_TYPE_IMPORTER [CP_IMPORTABLE]
	imp_importer: detachable CP_IMPORTER [ANY]
	imp_no_importer: detachable CP_NO_IMPORTER [ANY]
	imp_static: detachable CP_STATIC_TYPE_IMPORTER [CP_IMPORTABLE]

		-- Process
	prc_intermittent: detachable CP_INTERMITTENT_PROCESS
	prc_pace: detachable CP_PACEMAKER
	prc_period: detachable CP_PERIODIC_PROCESS
	prc_continous: detachable CP_CONTINUOUS_PROCESS

		-- Promise
	promise: detachable CP_PROMISE
	promise_proxy: detachable CP_PROMISE_PROXY
	promise_utils: detachable CP_RESULT_PROMISE [ANY]
	promise_result_proxy: detachable CP_RESULT_PROMISE_PROXY [ANY, CP_IMPORT_STRATEGY [ANY]]

		-- Queue
	queue_proxy: detachable CP_QUEUE_PROXY [ANY, CP_IMPORT_STRATEGY [ANY]]

		-- Util
	util_periodic_agent: detachable CP_PERIODIC_AGENT_PROCESS
	util_string_importer: detachable CP_STRING_IMPORTER

		-- Worker
	work_proxy: detachable CP_WORKER_POOL_PROXY [ANY]
	work_utils: detachable CP_WORKER_POOL_UTILS [ANY]

	rand: RANDOMIZER
			-- To bring in-system in project.
		once
			create Result
		end

end
