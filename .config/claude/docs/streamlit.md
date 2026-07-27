# Streamlit

Version-sensitive guidance for writing, editing, and reviewing Streamlit code.

- Follow the API supported by the project's pinned Streamlit version.
- Verify element-specific parameters in the current official documentation.
- Do not introduce the deprecated `use_container_width` parameter when the element supports `width`.
- Replace `use_container_width=True` with `width="stretch"`. For `use_container_width=False`, use `width="content"` only when that value is supported by the element; otherwise follow its documented `width` options.
