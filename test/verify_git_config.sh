#!/bin/sh

# TODO: improve console output
test_config_git() {
    echo "Storing current user config values..."
    get_current_user_config

    echo "Setting values to test git config..."
    set_git_config "${INPUT_GIT_CONFIG_USER}" "${INPUT_GIT_CONFIG_EMAIL}" "${INPUT_GIT_CONFIG_PULL_REBASE}"

    verify_set_config
    reset_git_config
    verify_reset_config
}

# store current user config data for reset after action run
get_current_user_config() {
    CURRENT_USER=$(git config --get --default="null" user.name)
    CURRENT_EMAIL=$(git config --get --default="null" user.email)
    CURRENT_PULL_CONFIG=$(git config --get --default="null" pull.rebase)
}

# set action config values
set_git_config() {
    git config user.name "${1}"
    git config user.email "${2}"
    git config pull.rebase "${3}"
}

# verify test values have been set
verify_set_config() {
    echo "Git config test 1 -> user.name should equal '${INPUT_GIT_CONFIG_USER}'"
    TEST_NAME_RESULT=$(git config --get user.name)

    if [ "${TEST_NAME_RESULT}" = "${INPUT_GIT_CONFIG_USER}" ]; then
        echo "Test 1 PASSED"
    else
        echo "Test 1 FAILED - user.name is '${TEST_NAME_RESULT}'"
    fi

    echo "Git config test 2 -> user.email should equal '${INPUT_GIT_CONFIG_EMAIL}'"
    TEST_EMAIL_RESULT=$(git config --get user.email)

    if [ "${TEST_EMAIL_RESULT}" = "${INPUT_GIT_CONFIG_EMAIL}" ]; then
        echo "Test 2 PASSED"
    else
        echo "Test 2 FAILED - user.email is '${TEST_EMAIL_RESULT}'"
    fi

    echo "Git config test 3 -> pull.rebase should equal '${INPUT_GIT_CONFIG_PULL_REBASE}'"
    TEST_PULL_CONFIG_RESULT=$(git config --get pull.rebase)

    if [ "${TEST_PULL_CONFIG_RESULT}" = "${INPUT_GIT_CONFIG_PULL_REBASE}" ]; then
        echo "Test 3 PASSED"
    else
        echo "Test 3 FAILED - pull.rebase is '${TEST_PULL_CONFIG_RESULT}'"
    fi
}

# reset to original user config values
reset_git_config() {
    if [ "${CURRENT_USER}" = "null" ]; then
        git config --unset user.name
    else
        git config user.name "${CURRENT_USER}"
    fi

    if [ "${CURRENT_EMAIL}" = "null" ]; then
        git config --unset user.email
    else
        git config user.email "${CURRENT_EMAIL}"
    fi

    if [ "${CURRENT_PULL_CONFIG}" = "null" ]; then
        git config --unset pull.rebase
    else
        git config pull.rebase "${CURRENT_PULL_CONFIG}"
    fi
}

# verify original values
verify_reset_config() {
    RESET_USER=$(git config --get user.name)
    RESET_EMAIL=$(git config --get user.email)
    RESET_PULL_CONFIG=$(git config --get pull.rebase)

    if [ "${RESET_USER}" = "${CURRENT_USER}" ] &&
        [ "${RESET_EMAIL}" = "${CURRENT_EMAIL}" ] &&
        [ "${RESET_PULL_CONFIG}" = "${CURRENT_PULL_CONFIG}" ]; then
        echo "Config reset was successful. All settings back to original user values."
    else
        echo "Config reset failed. Please check your local config."
    fi
}
